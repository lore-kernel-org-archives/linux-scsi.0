From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH v2 0/2] message: fusion: Fix clang and checkpatch warnings
Date: Thu,  7 Jun 2018 09:17:07 +0530
Message-ID: <cover.1528342739.git.rvarsha016@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>, Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This patchset fixes extraneous parentheses clang warning and few
checkpatch issues.

Varsha Rao (2):
  message: fusion: Remove extra parentheses
  message: fusion: Replace NULL comparison

 drivers/message/fusion/mptbase.c | 50 ++++++++++++++++----------------
 1 file changed, 25 insertions(+), 25 deletions(-)

-- 
2.17.0
