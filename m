From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: [Scst-devel] [ANNOUNCE]: Comparison of features sets between
 	different SCSI targets (SCST, STGT, IET, LIO)
Date: Mon, 06 Apr 2009 12:40:28 +0200
Message-ID: <49D9DC1C.3010100@wpkg.org>
References: <49D7AD54.4060408@vlnb.net> <49D7B122.50103@wpkg.org> <e2e108260904050429lcd1870ag6656f36a170ccab3@mail.gmail.com> <49D9D9A0.40106@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([78.111.66.105]:60109 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826AbZDFKkf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2009 06:40:35 -0400
In-Reply-To: <49D9D9A0.40106@wpkg.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@hansenpartnership.com>, scst-devel <scst-devel@lists.sourceforge.net>, stgt@vger.kernel.org

Tomasz Chmielewski schrieb:
> Bart Van Assche schrieb:
> 
>> Hello Tomasz,
>>
>> It would be great if you could publish the details of your setup and
>> the tests you have run, such that we are able to reproduce the tests
>> and analyze the results further.
> 
> Here it is.

(...)

> 2. Read-ahead on the initiator: 256 (default); md0, crypt - MB/s
> 
>                           md0   us  sy  id  wa  | crypt   us  sy  id  
> wa  STGT                      50.63   4% 45% 18% 33% | 32.52    3% 62% 

If you see these results not wrapped properly, it looks better here:

http://marc.info/?l=linux-kernel&m=123901387318274&w=4


-- 
Tomasz Chmielewski
http://wpkg.org
