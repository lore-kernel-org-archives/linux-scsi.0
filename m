From: Ying Li <hellbunni@yahoo.com>
Subject: Re: slow write speed
Date: Tue, 5 Apr 2005 12:22:35 -0700 (PDT)
Message-ID: <20050405192235.83825.qmail@web51302.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web51302.mail.yahoo.com ([206.190.38.168]:3201 "HELO
	web51302.mail.yahoo.com") by vger.kernel.org with SMTP
	id S261902AbVDETWg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Apr 2005 15:22:36 -0400
In-Reply-To: 6667
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Forgot to mention, I've tried the sg_dd program with
different bpt values.  Like 30,40,60,400,401,257,267. 
seems like whenever it's even the speeds is faster.

--- Ying Li <hellbunni@yahoo.com> wrote:
> hi,
> 
> I recently got a seagate cheetah (ST336753FC, 15k.3
> RPM 37GB) harddrive that sits in my JMR Fortra 2G6
> array.
> I'm running Linux 2.6, using sg3_util.1.13
> 
> My seagate is mapped to /dev/sdb
> I run the following:
> 
> 1.)time sg_dd if=/dev/zero of=/dev/sdb bpt=256
> count=1200000
>   a.) it finishes on average around 10 seconds
> 
> 2.)time sg_dd if=/dev/zero of=/dev/sdb bpt=255
> count=1200000
>   a.) this finishes on average around 18 seconds
> 
> Why is there such a big difference?
> 
> In a program that I wrote, 
>  --one pc reads data from one hd
>  --transfers it over a closed network
>  --another pc writes the data received to another hd
> 
> When I had both the hd being as seagate cheetah
> (ST318453FC, 15k RPM 17GB), I was getting good
> overall
>   (transfer + read/write) speed around 300Mb/s.  The
> drives sit in the JMR Fortra 2G6 array.  But when I
> replaced one of these with my new 37GB hd, i get
> weird
> resuls.
>   --if the 37GB replaced the one data is written to,
> my overall speed drops by a factor of 100Mb/s
>   --if the 37GB replaced the one data is read off
> of,
> my overall speed remains at 300Mb/s.
> 
> Any help would be greatly appreciated.  THANKS!!!
> 
> -Ying
> 
> __________________________________________________
> Do You Yahoo!?
> Tired of spam?  Yahoo! Mail has the best spam
> protection around 
> http://mail.yahoo.com 
> 


		
__________________________________ 
Do you Yahoo!? 
Yahoo! Small Business - Try our new resources site!
http://smallbusiness.yahoo.com/resources/ 
