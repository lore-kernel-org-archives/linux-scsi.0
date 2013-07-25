From: Andy Grover <agrover@redhat.com>
Subject: Re: targetcli -fb now also Apache 2.0 licensed
Date: Wed, 24 Jul 2013 17:06:47 -0700
Message-ID: <51F06C17.50306@redhat.com>
References: <51EF73EF.1040305@redhat.com>  <1374696565.7397.1292.camel@haakon3.risingtidesystems.com>  <1374697264.7382.39.camel@dabdike> <1374699289.7397.1309.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1374699289.7397.1309.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Ritesh Raj Sarraf <rrs@debian.org>, targetcli-fb-devel@lists.fedorahosted.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 07/24/2013 01:54 PM, Nicholas A. Bellinger wrote:
> Yes, which is why I've been accepting his kernel patches the entire time
> that user-space has been forked into -fb.  Now that the user-space code
> has been relicensed as promised, there is no longer any reason for a
> separate -fb fork to exist.
>
> That said, it's time to start moving forward toward a single set of
> source trees for upstream userspace, so that all distributions can
> mutually benefit from the effort.  As mentioned above, this has so far
> not been enough to get -fb reconciled with upstream.
>
> So I don't consider the above 'holding for ransom' or any nonsense like
> that, considering the end goal is for everyone (not just Fedora) to
> benefit from -fb.

There's nothing stopping any other distro (or commercial entity) from 
adopting targetcli-fb. I don't know why they haven't, except that 
there's a default attitude that the originator of the project is the 
"upstream" forever.

I think I've done a pretty good job maintaining -fb over the past two 
years -- -fb has bug tracking, a list, tarballs, and is actively 
maintained and improved, all things that are not true of upstream.

My question to you (Nick) is, why don't we all just unify on -fb?

Regards -- Andy
(at oscon this week, replies may be delayed)
