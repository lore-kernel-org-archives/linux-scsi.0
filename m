From: "Norman Diamond" <n0diamond@yahoo.co.jp>
Subject: Re: sg timeout problem
Date: Fri, 8 May 2009 20:22:23 +0900
Message-ID: <AB775258E58247F6A0960B1AFEC0E103@DIAMOND8600>
References: <BB8F41726E2941CEB399F732BB3ED9E5@DIAMOND8600> <20090506103852.19cb69b9@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp11.mail.tnz.yahoo.co.jp ([203.216.226.139]:35978 "HELO
	smtp11.mail.tnz.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753466AbZEHLWi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2009 07:22:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>> But if sg is running on top of an actual SCSI driver, someone aborts the
>> ioctl after 3 seconds.  The ioctl returns success even though the
>> operation didn't complete.  I tried this with two Adaptec drivers and one
>> NinjaSCSI driver with 100% repro.
>>
>> What am I missing?  I need the call to run to completion.
>
> If you set it to the max of a signed int does it behave, or to a large
> value thats well under the limit. That will help tell if there is a
> problem with sign handling in the scsi code somewhere or it is getting
> multiplied up for some reason.

I have the impression now that the drives are lying and it's not the fault
of the drivers or cards.  The same problem occured with a fourth card and a
non-Linux system.

Anyway I also tried changing the timeout to 86400000 milliseconds (one day)
and it made no difference.  So again I stop blaming the drivers.

--------------------------------------
Power up the Internet with Yahoo! Toolbar.
http://pr.mail.yahoo.co.jp/toolbar/
