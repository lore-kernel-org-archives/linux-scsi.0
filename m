From: "Akinobu Mita" <akinobu.mita@gmail.com>
Subject: Re: [PATCH] a100u2w: fix bitmap lookup routine
Date: Mon, 17 Mar 2008 22:45:52 +0900
Message-ID: <961aa3350803170645m4f865e2bu892fcdd94c83f212@mail.gmail.com>
References: <20080317123200.GA17756@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.239]:34253 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbYCQNpy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2008 09:45:54 -0400
Received: by wr-out-0506.google.com with SMTP id c48so3964433wra.1
        for <linux-scsi@vger.kernel.org>; Mon, 17 Mar 2008 06:45:54 -0700 (PDT)
In-Reply-To: <20080317123200.GA17756@APFDCB5C>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@hansenpartnership.com, Alan Cox <alan@redhat.com>, Christoph Hellwig <hch@lst.de>, Doug Ledford <dledford@redhat.com>

2008/3/17, Akinobu Mita <akinobu.mita@gmail.com>:
> This patch is only compile tested.
>
>  It seems that bitmap lookup routine for allocation_map in
>  a100u2w driver is simply wrong.
>
>  It cannot lookup more than first 32 bits. If all first 32 bits
>  are set, it just returns 33-th orc_scb even though the 33-th bit

   are "not" set, ...

>  is not set.
>
