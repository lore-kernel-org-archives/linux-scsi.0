From: "David Anderson" <david-ander2023@mail.com>
Subject: Reading data from a file
Date: Fri, 27 Dec 2002 10:34:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021227153427.70720.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I am reading some data from a file byte by byte in my driver. Although it's not a good thing to read a file in the driver I have to do it. My file is quite big can contain about 1000 lines each line containing anywhere from 0 to 500 characters. I believe carry out 500000 reads is not a good thing. 

Any suggestions on how I can improve ??

Thanks and Regards,
David
-- 
__________________________________________________________
Sign-up for your own FREE Personalized E-mail at Mail.com
http://www.mail.com/?sr=signup

Meet Singles
http://corp.mail.com/lavalife

