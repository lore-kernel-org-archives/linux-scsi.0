From: "Michael Lyulko" <mlyulko@gmail.com>
Subject: SCSI Mid layer sends READ_10 cmd that starts in the middle of a sector
Date: Wed, 4 Oct 2006 21:32:35 +0200
Message-ID: <53d68ba60610041232l7e4a16fco820d74d43f0b7f3a@mail.gmail.com>
References: <53d68ba60610041231ub88916al1762cfabfc3232dd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:25420 "EHLO
	py-out-1112.google.com") by vger.kernel.org with ESMTP
	id S1750857AbWJDTcg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Oct 2006 15:32:36 -0400
Received: by py-out-1112.google.com with SMTP id n25so397926pyg
        for <linux-scsi@vger.kernel.org>; Wed, 04 Oct 2006 12:32:35 -0700 (PDT)
In-Reply-To: <53d68ba60610041231ub88916al1762cfabfc3232dd@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello, all. I'm writing a kind of low level driver and trying to
register it with scsi mid layer. During the registration process I
receive from the mid layer READ_10 command that tries to read one
block starting from the middle of a block (block size is 4K and it
reads from address 2048). It doesn't seems normal to me, so what do
you say?
As I understand, the right place to tell mid layer about the block
size is the answer to READ_CAPACITY command, am I right?
Any tips are welcome!
Thanks in advance,
Michael.
