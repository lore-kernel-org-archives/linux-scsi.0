From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bfa: remove VLA
Date: Thu, 15 Mar 2018 00:37:20 -0400
Message-ID: <yq18tau7y4f.fsf@oracle.com>
References: <20180308213841.13807-1-steve@sk2.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-hardening-return-12620-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20180308213841.13807-1-steve@sk2.org> (Stephen Kitt's message of
	"Thu, 8 Mar 2018 22:38:41 +0100")
To: Stephen Kitt <steve@sk2.org>
Cc: hare@suse.com, linux-scsi@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Stephen,

> bfad_bsg.c uses a variable-length array declaration to measure the
> size of a putative array; this can be replaced by the product of the
> size of an element and the number of elements, avoiding the VLA
> altogether.
>
> -		sizeof(wwn_t[iocmd->nports])) != BFA_STATUS_OK) {
> +		sizeof(wwn_t) * iocmd->nports) != BFA_STATUS_OK) {

These parentheses made me blurry eyed but it's actually OK.

Applied to 4.17/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
