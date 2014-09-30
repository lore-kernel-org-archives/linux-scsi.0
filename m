From: Jerome Martin <jxm@netiant.com>
Subject: Re: targetcli do not show iscsi
Date: Tue, 30 Sep 2014 19:09:54 +0200
Message-ID: <542AE3E2.1080609@netiant.com>
References: <542A6F44.3070802@gmail.com> <542A7037.6050909@netiant.com> <542A722E.5030109@gmail.com> <542A73BE.2080501@netiant.com> <542A75F1.8070706@gmail.com> <542A77D6.4090109@netiant.com> <542A7ADD.3040804@gmail.com> <542A7BC9.2050708@netiant.com> <542ACA6C.104@redhat.com> <542ACDAE.3080307@gmail.com> <542AD1C2.8070105@gmail.com> <542ADF1D.1020003@gmail.com> <542ADFDB.3010300@netiant.com> <542AE206.4000808@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <542AE206.4000808@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Luigi Tarenga <luigi.tarenga@gmail.com>
Cc: Andy Grover <agrover@redhat.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 09/30/2014 07:01 PM, Luigi Tarenga wrote:
>
> On 09/30/2014 06:52 PM, Jerome Martin wrote:
> oops... ok Jerome I'll be happy to help doing some tests.
> Just forgive me, I'm very new to LIO:
> what do you mean for v3.x?

I mean targetcli version 3.x

> or the targetcli branch from Datera?

OK, as you are new, a little catchup summary :-)

The "targetcli branch from Datera" is the main targetcli repository.
I am actually the original author of targetcli, and still develop it 
using the Datera repository on GitHub, which is the official home for 
targetcli on the web.

The "fb" branch done by Andy is a fork of targetcli version 2, and is 
used in RedHat distributions.

If you look a bit in the mailing list, you'll also notice discussions 
with Andy to reunify his fork and my code.

Best,
--
Jerome
