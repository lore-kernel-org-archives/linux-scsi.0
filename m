From: mchristi@redhat.com
Subject: [PATCH 0/5] block/target queue/LUN reset support
Date: Wed, 25 May 2016 02:54:58 -0500
Message-ID: <1464162903-14735-1-git-send-email-mchristi@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Currently, for SCSI LUN_RESETs the target layer can only wait on
bio/requests it has sent. This normally results in the LUN_RESET
timing out on the initiator side and that SCSI error handler
escalating to something more disruptive.

To fix this, the following patches add a block layer helper and
callout to reset a request queue which the target layer can use
to force drivers to complete/fail executing requests.

Patches were made over Jens's block tree's for-next branch.
