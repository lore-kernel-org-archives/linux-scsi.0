From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH 0/3] message: fusion: Fix clang and checkpatch warnings
Date: Sun,  3 Jun 2018 18:50:09 +0530
Message-ID: <cover.1528031458.git.rvarsha016@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>, Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This patchset fixes extraneous parentheses clang warning and few
checkpatch issues.

Varsha Rao (3):
  message: fusion: Remove extra parentheses
  message: fusion: Replace NULL comparison
  message: fusion: Fix line over 80 characters

 drivers/message/fusion/mptbase.c | 50 ++++++++++++++++----------------
 1 file changed, 25 insertions(+), 25 deletions(-)

-- 
2.17.0
