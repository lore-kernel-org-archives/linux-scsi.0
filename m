From: =?UTF-8?B?6ZKi6ZmI?= <ggggchen@gmail.com>
Subject: what's the requirement if multi queuing commands access the same LBAs
Date: Mon, 30 Jan 2012 18:40:17 +0800
Message-ID: <CALpNg8cus+ZCiMrkd-zn5_om23dqf7=g5vY0r5SakiwVi_3AsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58780 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab2A3KkS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2012 05:40:18 -0500
Received: by ggnb1 with SMTP id b1so1718741ggn.19
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2012 02:40:17 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,
How about below below cases.

All the requests are queue commands and they are not returned.

here assume w(1,1, 5) means write lba 1 and length is 1 and the
content is 5 filled. and r(1,1) means read lba 1 and length is 1.


The scsi target device receives 6 queue commands that all access lba 1.

1) w(1,1, 2)

2) r( 1,1)

3) w(1,1,3)

4)r(1,1)

5) w(1,1,4)

6) r(1,1)

I have some questions, If the scsi target device receives this serial commands,
  1)  can the request return not in order?
  2)  is it ok that all the 3 read commands return finally and all out
data buffer is filled by 4.
  3)  is it ok that all the 3 read commands return finally and all out
data buffer is filled by 3. And finally the content in lba 1 is 3.


thanks.
