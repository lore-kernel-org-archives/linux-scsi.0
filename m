From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC PATCH] mpt3sas: mpt3sas_scsih_enclosure_find_by_handle can be static
Date: Wed, 28 Mar 2018 17:54:35 -0400
Message-ID: <yq1370jj278.fsf@oracle.com>
References: <1521540956-42347-1-git-send-email-chaitra.basappa@broadcom.com>
        <20180320210652.GA40906@xian>
        <289588bbff4dc0d35e519d0c4d4282da78cc6121.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <289588bbff4dc0d35e519d0c4d4282da78cc6121.camel@wdc.com> (Bart
        Van Assche's message of "Tue, 27 Mar 2018 18:55:19 +0000")
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "lkp@intel.com" <lkp@intel.com>, "kbuild-all@01.org" <kbuild-all@01.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sathya.Prakash@broadcom.com" <Sathya.Prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "jaco@uls.co.za" <jaco@uls.co.za>
List-Id: linux-scsi@vger.kernel.org


Bart,

> Are you aware that if the 0-day test infrastructure suggests an improvement
> for a patch that the patch that that improvement applies to gets ignored
> unless either the patch is reposted with the improvement applied or that it
> is explained why the suggested improvement is inappropriate?

Correct. I don't apply anything that causes a 0-day warning. The patch
will be closed with "Changes Required" status in patchwork.

Always build patch submissions to linux-scsi with:

	make C=1 CF="-D__CHECK_ENDIAN__"

-- 
Martin K. Petersen	Oracle Linux Engineering
