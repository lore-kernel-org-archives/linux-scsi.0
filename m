From: Andy Grover <agrover@redhat.com>
Subject: Re: targetcli -fb now also Apache 2.0 licensed
Date: Thu, 25 Jul 2013 20:31:41 -0700
Message-ID: <51F1ED9D.50300@redhat.com>
References: <51EF73EF.1040305@redhat.com>  <1374696565.7397.1292.camel@haakon3.risingtidesystems.com>  <1374697264.7382.39.camel@dabdike>  <1374699289.7397.1309.camel@haakon3.risingtidesystems.com>  <51F06C17.50306@redhat.com> <1374715140.7397.1390.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1374715140.7397.1390.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Ritesh Raj Sarraf <rrs@debian.org>, targetcli-fb-devel@lists.fedorahosted.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 07/24/2013 06:19 PM, Nicholas A. Bellinger wrote:
> Because -fb has had close to zero peer review, and you've not solicited
> much input (none from us) before making significant changes to
> rtslib/targetcli over the past 1 1/2 years.
>
> For your own private tree this wouldn't matter.  However, for a single
> upstream tree moving forward, it seems irresponsible to just ask us to
> sign off on every decision that you've made in -fb with little external
> review or input.
>
> So, to help us get back to a community development model, please cut a
> -fb branch against upstream rtslib/configshell/targetcli, and start
> sending the series out for public review.

Hi Nick,

It's one thing to claim a prerogative of "upstream", but for this to 
make sense, there needs to be an actual community around the upstream. 
And if there's going to be submissions for review, then there needs to 
be someone in charge of the community with a high degree of skill in the 
code base. Nick you have a great deal of technical expertise around the 
C code in drivers/target, but Jerome was the one who wrote rtslib, 
targetcli, and configshell. I believe you can assess the technical 
aspects of how the user library interacts with the kernel code, but the 
maintainer should also be extremely conversant in the language the 
library is written in. In this case, Python. So it's not clear to me if 
submitting the code would actually result in meaningful code improvements.

Also, there has been no effort to sustain a community around this code. 
There is no bug tracking, no separate mailing list, no regular releases. 
Debian is running ancient, broken code because nothing's been tagged in 
over two years.

I would love to have you maintain and improve this code, but if you 
aren't then you can't just say "I'm the upstream bow to me!". We're 
shipping this code in Fedora and it needs active maintenance. Now that 
we're all on an even licensing footing, code can flow both ways, and 
even into your commercial version.

So, if you get a Pythonista to maintain upstream, and actually work to 
build a community around it, then I will play ball. But I must ask you, 
do you *really* want to maintain this? Forever? In a private thread a 
while back, RTS CEO Marc said your company's value-add was in different 
areas now. It might actually be easier for you to hire a Python person 
to reconcile targetcli-fb with your commercial needs, and then just 
track it. The objection I have with what you're asking me is that it 
feels like you're trying to get me to do that reconciliation work for 
you for free as a condition of being "upstream", and I'm not willing to 
do work that benefits only your company and not the community at large.

Regards -- Andy
