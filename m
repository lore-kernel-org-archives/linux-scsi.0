From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: Re: [PATCH] mptlan: fix mpt_lan_sdu_send()'s return type
Date: Tue, 8 May 2018 17:44:16 +0200
Message-ID: <20180508154415.neutsgpi2nwffwec@ltop.local>
References: <20180424131558.3010-1-luc.vanoostenryck@gmail.com>
 <yq1h8niyb63.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1h8niyb63.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, May 08, 2018 at 01:21:56AM -0400, Martin K. Petersen wrote:
> 
> Luc,
> 
> > The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
> > which is a typedef for an enum type, but the implementation in this
> > driver returns an 'int'.
> 
> You forgot to update the function prototype accordingly.

Hmmm, the function mpt_lan_sdu_send() has no other declaration
than the one I modified the return type in this patch.

Must be a misunderstanding somewhere.

-- Luc
