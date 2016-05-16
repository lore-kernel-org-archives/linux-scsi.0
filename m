From: mchristi@redhat.com
Subject: [PATCH 0/2] fix max discard sectors calculation
Date: Mon, 16 May 2016 13:46:48 -0500
Message-ID: <1463424410-17196-1-git-send-email-mchristi@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, socketpair@gmail.com
List-Id: linux-scsi@vger.kernel.org

The following patches were made over Linus's tree. They
fix the max discard sectors calculation in the target
layer and SCSI.

The second patch is a regression fix, so I am ccing stable.
