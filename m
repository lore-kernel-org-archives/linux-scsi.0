From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpt3sas: Fix resume on WarpDrive flash cards
Date: Fri, 12 Aug 2016 16:13:06 -0400
Message-ID: <yq11t1toiel.fsf@sermon.lab.mkp.net>
References: <1469894786-27917-1-git-send-email-gedwards@fireweed.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1469894786-27917-1-git-send-email-gedwards@fireweed.org> (Greg
	Edwards's message of "Sat, 30 Jul 2016 10:06:26 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Edwards <gedwards@fireweed.org>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Greg" == Greg Edwards <gedwards@fireweed.org> writes:

Greg> mpt3sas crashes on resume after suspend with WarpDrive flash
Greg> cards.  The reply_post_host_index array is not set back up after
Greg> the resume, and we deference a stale pointer in _base_interrupt().

Applied to 4.8/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
