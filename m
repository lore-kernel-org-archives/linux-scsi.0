From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: Thu, 17 Jul 2003 17:00:55 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030717170055.5dbe20c1.akpm@osdl.org>
References: <20030716132036.GB833@suse.de>
	<1058364455.1856.28.camel@mulgrave>
	<20030716170456.GK833@suse.de>
	<20030717015756.135a3f5a.akpm@osdl.org>
	<20030717085952.GX833@suse.de>
	<3F1672D9.7070309@cyberone.com.au>
	<20030717102926.GE833@suse.de>
	<3F167F98.60006@cyberone.com.au>
	<20030717105641.GF833@suse.de>
	<3F1683F5.4030107@cyberone.com.au>
	<20030717111059.GI833@suse.de>
	<3F168846.90902@cyberone.com.au>
	<1058474814.4638.11.camel@markh1.pdx.osdl.net>
	<1058481553.19508.5.camel@markh1.pdx.osdl.net>
	<1058485621.7424.30.camel@dell_ss5.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:43195 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S271644AbTGQXxe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 19:53:34 -0400
In-Reply-To: <1058485621.7424.30.camel@dell_ss5.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Daniel McNeil <daniel@osdl.org>
Cc: markh@osdl.org, piggin@cyberone.com.au, axboe@suse.de, James.Bottomley@steeleye.com, cliffw@osdl.org, linux-scsi@vger.kernel.org

Daniel McNeil <daniel@osdl.org> wrote:
>
> Should	
> 	list_add(&rq->queuelist, ad->dispatch->prev);
> be
> 	list_add_tail(&rq->queuelist, ad->dispatch);
> 
> It is equivalent, but makes the code clearer that we're adding to the
> end.

yup.

> Also, isn't the: !list_empty(ad->dispatch) unnecessary since a
> list_add was just done, so the list cannot be empty?

more yup.
