From: Kenneth Porter <shiva@sewingwitch.com>
Subject: Re: books on scsi for linux
Date: Mon, 10 Oct 2005 14:08:34 -0700
Message-ID: <A143EF527CF23FBAE56DA6FB@[10.0.0.14]>
References: <43439CD5.3010808@cdac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segw.microprecisionautomation.com ([69.17.55.168]:58344 "EHLO
	segw.microprecisionautomation.com") by vger.kernel.org with ESMTP
	id S1751192AbVJJVIy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Oct 2005 17:08:54 -0400
In-Reply-To: <43439CD5.3010808@cdac.in>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Karthik Sarangan <karthiks@cdac.in>

No idea how relevant these are but probably a good place to start:

<http://kernelbook.sourceforge.net/>

<http://www.xml.com/ldd/chapter/book/ch04.html>

Here's the search that turned these up:

<http://www.google.com/search?hl=en&q=linux+source+code+book&btnG=Google+Search>

The problem with your original question:

> Can anyone tell me which books/ebooks/articles on scsi subsystem for
> linux are good?

is that it doesn't reflect the level of reader. If you don't know anything 
about SCSI, you should start with something on the bus, independent of the 
OS. Then read about the OS, using one of the above books. Then read the 
source code, to see how they connect.
