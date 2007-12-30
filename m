From: "Miquel van Smoorenburg" <miquels@cistron.nl>
Subject: Re: Adaptec 2410SA, aacraid, managment
Date: 30 Dec 2007 10:27:56 GMT
Message-ID: <477772ac$0$85790$e4fe514c@news.xs4all.nl>
References: <47758245.8070408@nectarine.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1930 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbXL3Kll (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Dec 2007 05:41:41 -0500
Received: from post.news.xs4all.nl (post.news.xs4all.nl [194.109.133.244])
	by smtp-vbr16.xs4all.nl (8.13.8/8.13.8) with ESMTP id lBUARvHq082016
	for <linux-scsi@vger.kernel.org>; Sun, 30 Dec 2007 11:27:57 +0100 (CET)
	(envelope-from mailnull@post.news.xs4all.nl)
Received: from post.news.xs4all.nl (localhost [127.0.0.1])
	by post.news.xs4all.nl (8.13.8/8.13.8) with ESMTP id lBUARv2d027111
	for <linux-scsi@vger.kernel.org>; Sun, 30 Dec 2007 11:27:57 +0100 (CET)
	(envelope-from mailnull@post.news.xs4all.nl)
In-Reply-To: <47758245.8070408@nectarine.info>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

In article <47758245.8070408@nectarine.info>,
Giacomo Di Ciocco  <admin@nectarine.info> wrote:
>Hello subscribers,
>theres any utility to query/manage controller status/features ?
>
>I'm using this card for a Raid 10 array made of four 300GB sata disks, 
>on a debian sarge with kernel 2.6.19.1-grsec. It runs on a dual opteron 
>Tyan GT24 transport and operates principally as mail and web server.

You can download the 'storage manager' software from the adaptec
site. It includes GUI and CLI (arcconf) tools.

http://linux.adaptec.com/2007/11/15/how-to-monitor-the-status-of-arrays-in-ubuntu-710/

Mike.
