From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: IBM VSCSI Target Driver Initial Patch Sets
Date: Wed, 25 May 2016 09:17:32 -0500
Message-ID: <1464185854-19761-1-git-send-email-bryantly@linux.vnet.ibm.com>
References: <1464097978-88457-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1464097978-88457-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: tyreld@linux.vnet.ibm.com, bart.vanassche@sandisk.com, joe@perches.com
Cc: martin.petersen@oracle.com, akpm@linux-foundation.org, kvalo@codeaurora.org, davem@davemloft.net, mchehab@osg.samsung.com, jslaby@suse.com, bp@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch series addresses comments by Joe with runing checkpatch with a
--strict. It cleans up all the misc styling and removes all the forward
declarations.

The patch also addresses all of Bart's comments besides the preallocation of
buffers before IO starts and the merging of unpack_lun with scsiluntoint.
Those will come in later patch sets.

[PATCH 2/3] ibmvscsis: Addressing Bart's comments
[PATCH 3/3] ibmvscsis: clean up functions
