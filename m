From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Patch] zfcp: act enhancements corrections
Date: Mon, 29 Nov 2004 14:08:31 +0100
Message-ID: <1101733711.2814.65.camel@laptop.fenrus.org>
References: <OF2C369516.E9283E52-ONC1256F5B.003A1DCC-C1256F5B.0047384F@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:24838 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S261721AbUK2NIo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Nov 2004 08:08:44 -0500
In-Reply-To: <OF2C369516.E9283E52-ONC1256F5B.003A1DCC-C1256F5B.0047384F@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <AHERRMAN@de.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Mon, 2004-11-29 at 13:57 +0100, Andreas Herrmann wrote:
> @@ -3196,6 +3149,8 @@
>             }
>             debug_text_event(adapter->erp_dbf, 1, "fsf_s_access");
>             zfcp_erp_unit_access_denied(unit);
> +           atomic_clear_mask(ZFCP_STATUS_UNIT_SHARED, &unit->status);
> +                atomic_clear_mask(ZFCP_STATUS_UNIT_READONLY, &unit->status);
>             fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
>             break;
> 

are you sure that was intentional ?
-- 

