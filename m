From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ibmvfc: fix misdefined reserved field in ibmvfc_fcp_rsp_info
Date: Tue, 30 Jan 2018 21:16:55 -0500
Message-ID: <yq11si6hiw8.fsf@oracle.com>
References: <1516759892-31245-1-git-send-email-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1516759892-31245-1-git-send-email-tyreld@linux.vnet.ibm.com>
        (Tyrel Datwyler's message of "Tue, 23 Jan 2018 20:11:32 -0600")
Sender: stable-owner@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, brking@linux.vnet.ibm.com, nfont@linux.vnet.ibm.com, hare@suse.de, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Tyrel,

> The fcp_rsp_info structure as defined in the FC spec has an initial 3 bytes
> reserved field. The ibmvfc driver mistakenly defined this field as 4 bytes
> resulting in the rsp_code field being defined in what should be the start of
> the second reserved field and thus always being reported as zero by the
> driver.

Applied to 4.16/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
