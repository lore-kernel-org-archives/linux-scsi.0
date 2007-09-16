From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 10/17] advansys: Remove asc_board_t typedef and ASC_BOARDP macro
Date: Sun, 16 Sep 2007 10:14:21 -0600
Message-ID: <20070916161421.GB28350@parisc-linux.org>
References: <1189867145.3339.3.camel@localhost.localdomain> <11899570694170-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:40795 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbXIPQOW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Sep 2007 12:14:22 -0400
Content-Disposition: inline
In-Reply-To: <11899570694170-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Sun, Sep 16, 2007 at 09:37:41AM -0600, Matthew Wilcox wrote:
> @@ -2475,7 +2469,7 @@ typedef struct adv_req {
>   * of the 'Scsi_Host' structure starting at the 'hostdata'
>   * field. It is guaranteed to be allocated from DMA-able memory.
>   */
> -typedef struct asc_board {
> +struct asc_board {
>  	struct device *dev;
>  	int id;			/* Board Id */
>  	uint flags;		/* Board flags */
> @@ -2523,7 +2517,7 @@ typedef struct asc_board {
>  	ushort bios_version;	/* BIOS Version. */
>  	ushort bios_codeseg;	/* BIOS Code Segment. */
>  	ushort bios_codelen;	/* BIOS Code Segment Length. */
> -} asc_board_t;
> +} asc_board;
>  
>  #define adv_dvc_to_board(adv_dvc) container_of(adv_dvc, struct asc_board, \
>  							dvc_var.adv_dvc_var)

"oops".  I'll send a replacement for this patch.  I can't believe this
struct is 512 bytes.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
