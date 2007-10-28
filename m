From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [2.6 patch] scsi/seagate.c: remove dead code
Date: Sun, 28 Oct 2007 09:53:54 -0600
Message-ID: <20071028155354.GJ27248@parisc-linux.org>
References: <20071028155142.GB7227@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49092 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbXJ1Pxz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Oct 2007 11:53:55 -0400
Content-Disposition: inline
In-Reply-To: <20071028155142.GB7227@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 04:51:42PM +0100, Adrian Bunk wrote:
> This patch removes obviously dead code.
>  				case LINKED_WRONG:
>  					WRITE_DATA (ABORT);
>  					linked_connected = 0;
>  					reselect = CAN_RECONNECT;
>  					goto connect_loop;
> -					DPRINTK (PHASE_MSGOUT | DEBUG_LINKED, "scsi%d : sent ABORT message to cancel incorrect I_T_L nexus.\n", hostno);
>  #endif					/* LINKED */
> -					DPRINTK (DEBUG_LINKED, "correct\n");
>  				default:

Surely the 'goto' should just be moved two lines down?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
