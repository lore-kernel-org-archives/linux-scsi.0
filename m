From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Subject: [PATCH 0/2] fusion: Remove deprecated create_singlethread_workqueue
Date: Wed, 31 Aug 2016 00:32:37 +0530
Message-ID: <cover.1472583639.git.bhaktipriya96@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch set removes deprecated create_singlethread_workqueue
instances from drivers/message

Bhaktipriya Shridhar (2):
  fusion/mptfc: Remove deprecated create_singlethread_workqueue
  fusion: mptbase: Remove deprecated create_singlethread_workqueue

 drivers/message/fusion/mptbase.c | 7 ++++---
 drivers/message/fusion/mptfc.c   | 3 ++-
 2 files changed, 6 insertions(+), 4 deletions(-)

--
2.1.4
