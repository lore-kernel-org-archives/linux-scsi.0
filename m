From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/2] tcm_qla2xxx: Format VPD page 83h SCSI name string
 according to SPC
Date: Wed, 17 Oct 2012 14:22:02 -0700
Message-ID: <1350508922.10820.33.camel@haakon2.linux-iscsi.org>
References: <1349988092-27640-1-git-send-email-roland@kernel.org>
	 <1349988092-27640-2-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1349988092-27640-2-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Arun Easi <arun.easi@qlogic.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-10-11 at 13:41 -0700, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> My draft of SPC-4 says the following about the SCSI name string in
> inquiry VPD page 83h:
> 
>     The SCSI NAME STRING field starts with either:
> 
>     a) the four UTF-8 characters 'eui.' concatenated with 16, 24, or
>        32 hexadecimal digits (i.e., the UTF-8 characters 0 through 9
>        and A through F) for an EUI-64 based identifier (see
>        7.8.6.5). The first hexadecimal digit shall be the most
>        significant four bits of the first byte (i.e., most significant
>        byte) of the EUI-64 based identifier;
>     b) the four UTF-8 characters 'naa.' concatenated with 16 or 32
>        hexadecimal digits for an NAA identifier (see 7.8.6.6). The
>        first hexadecimal digit shall be the most significant four bits
>        of the first byte (i.e., most significant byte) of the NAA
>        identifier; or
>     c) the four UTF-8 characters 'iqn.' concatenated with an iSCSI
>        Name for an iSCSI-name based identifier (see iSCSI).
> 
> However, the .tpg_get_wwn method for tcm_qla2xxx formats the WWN so
> the SCSI name string looks like "52:4a:93:7d:24:5f:b2:12,t,0x0001".
> This patch corrects the code so that VPD 83h gives a SPC-compliant
> SCSI name string like "naa.524a937d245fb212,t,0x0001" while leavig
> other uses alone (so configfs will still work with ':' separated WWNs).
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---

Hi Roland,

Apologies for the delayed response on this patch.

Applied to target-pending/master and queued for v3.7-rc fixes

Thanks!
