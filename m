From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5 1/2] ibmvscsi: display default value for max_id, max_lun and max_channel.
Date: Wed, 11 Nov 2015 21:01:36 -0500
Message-ID: <yq1egfwt1q7.fsf@sermon.lab.mkp.net>
References: <1447087749-10828-1-git-send-email-lvivier@redhat.com>
	<1447087749-10828-2-git-send-email-lvivier@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447087749-10828-2-git-send-email-lvivier@redhat.com> (Laurent
	Vivier's message of "Mon, 9 Nov 2015 17:49:08 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Laurent Vivier <lvivier@redhat.com>
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, brking@linux.vnet.ibm.com, tyreld@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Laurent" == Laurent Vivier <lvivier@redhat.com> writes:

Laurent> As devices with values greater than that are silently ignored,
Laurent> this gives some hints to the sys admin to know why he doesn't
Laurent> see his devices...

Applied both patches.

-- 
Martin K. Petersen	Oracle Linux Engineering
