From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [RFC-v3 07/12] iscsi-target: Add CHAP Authentication support
 using libcrypto
Date: Fri, 18 Mar 2011 00:07:28 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1103180006130.14381@swampdragon.chaosbits.net>
References: <1300398797-24536-1-git-send-email-nab@linux-iscsi.org> <1300398797-24536-8-git-send-email-nab@linux-iscsi.org> <alpine.LNX.2.00.1103172331160.1980@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12359 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab1CQXHn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Mar 2011 19:07:43 -0400
In-Reply-To: <alpine.LNX.2.00.1103172331160.1980@swampdragon.chaosbits.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, Douglas Gilbert <dgilbert@interlog.com>

On Thu, 17 Mar 2011, Jesper Juhl wrote:

> On Thu, 17 Mar 2011, Nicholas A. Bellinger wrote:
> 
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> 
> Minor nitpicks below.
> 
> 
...
> 
> > +int chap_server_compute_md5(
> > +	struct iscsi_conn *conn,
> > +	struct iscsi_node_auth *auth,
> > +	char *NR_in_ptr,
> > +	char *NR_out_ptr,
> > +	unsigned int *NR_out_len)
> > +{
> > +	char *endptr;
> > +	unsigned char id, digest[MD5_SIGNATURE_SIZE];
> > +	unsigned char type, response[MD5_SIGNATURE_SIZE * 2 + 2];
> > +	unsigned char identifier[10], *challenge, *challenge_binhex;
> 
> If you changed the above line to 
> 
> 	unsigned char identifier[10], *challenge;
> 	unsigned char *challenge_binhex = 0;
> 

Actually, to be pedantic, that should probably be

	unsigned char *challenge_binhex = NULL;


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

