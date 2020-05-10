Return-Path: <SRS0=m8SI=6Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18A6C54E4B
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 05:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFB86208DB
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 05:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589089648;
	bh=PQW18kKBWbAlWkdnFkxJP6/JkC5E/quNbULzZyjKpn8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=rT3zGZewKyEBmG7BXYqUOY5+dtfSRdwl7SyI1GOeRf1y5TjI4E7UVlBZR7ADWgRBH
	 gjoFlYKQXf4x7Zf5BRmNlkjXIdMPST8PN/bCYKzqrGNNZnD0bwWowo2oIIo5cP6yLd
	 nOikIBVBbyXCoyD1pL62jLz0fJudrZkIeBq6XTQw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgEJFr0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 01:47:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgEJFrZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 May 2020 01:47:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E128208DB;
        Sun, 10 May 2020 05:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589089644;
        bh=PQW18kKBWbAlWkdnFkxJP6/JkC5E/quNbULzZyjKpn8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zxysiI+G3s1Pvj6eLxx/1R02SWLh/ifTeNg9BtlEhjxOYuEXaxadA4kVWVl2g7ycN
         nCxIJ5kv10ohnpWkSGn5aTgYME0f5Kq77o0udCByPUmx4JOC5qc4iVqr6Et9tJwxJz
         oE7obs0cgSC6og6ASDEtvLev0830C/G16RNNG2V0=
Date:   Sun, 10 May 2020 07:47:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dio Putra <dioput12@gmail.com>
Cc:     oneukum@suse.com, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        stern@rowland.harvard.edu, linux-kernel@vger.kernel.org
Subject: Re: USB Attached SCSI breakage due no udev involvement
Message-ID: <20200510054717.GA3365021@kroah.com>
References: <CAOyCV0zW_20Jq6Rrb9=fhZQAHeqMMs_oHBJdTVt8Nqje0Zoeig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOyCV0zW_20Jq6Rrb9=fhZQAHeqMMs_oHBJdTVt8Nqje0Zoeig@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, May 10, 2020 at 09:55:57AM +0700, Dio Putra wrote:
> Hi, it's first time for me to report user-space breakage in here, so
> i'm begging your pardon.
> 
> I want to report that Linux 5.4 breaking my USB mount workflow due
> udevadm monitor report here (I'm using vanilla kernel 5.4.39 on
> Slackware64 Current and vanilla kernel 4.4.221 on Slackware64 14.2):

<snip>

Sorry, but what actually changed that you can see in the logs?

What functionality broke?  What used to work that no longer does work?

And 4.4.221 is quite different from 5.4, is that the jump that you are
seeing breakage in, or is it in some smaller jump?

thanks,

greg k-h
