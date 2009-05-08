From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: [PATCHSET] block,scsi,libata: implement alt_size
Date: Fri, 8 May 2009 09:23:46 -0700
Message-ID: <e9c3a7c20905080923u12c2eddaq92012e919d52e784@mail.gmail.com>
References: <1233456951-992-1-git-send-email-tj@kernel.org>
	 <49F902CF.7080307@garzik.org> <49F903DD.8040707@kernel.org>
	 <49FA0349.3090706@garzik.org>
	 <e9c3a7c20904301415t621670a0l1bd64c7d74d369f@mail.gmail.com>
	 <49FEA127.1000905@kernel.org>
	 <e9c3a7c20905040948m572e23dj1aa197dbd20ff037@mail.gmail.com>
	 <49FFB275.7000507@kernel.org>
	 <e9c3a7c20905050834t79a1c03dt83df288b2f38ed76@mail.gmail.com>
	 <4A03F7A8.9090204@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A03F7A8.9090204@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Mauelshagen@redhat.com, device-mapper development <dm-devel@redhat.com>, heinzm@redhat.com
List-Id: linux-scsi@vger.kernel.org

[ added heinzm@redhat.com ]

On Fri, May 8, 2009 at 2:13 AM, Tejun Heo <tj@kernel.org> wrote:
> Dan Williams wrote:
>> On Mon, May 4, 2009 at 8:28 PM, Tejun Heo <tj@kernel.org> wrote:
>>> Pushing this in the kernel without updating dm-raid is kind of
>>> pointless. =A0Who should I be poking to get the userland part movin=
g?
>>
>> Dmraid is not the only potential user. =A0Mdadm will also care about
>> this as I have seen a report that points to a user having what looks
>> like an HPA issue with an Intel(R) Matrix array. =A0So, there are tw=
o
>> immediate users for this interface. =A0Heinz is the right person to =
poke
>> for dmraid updates. =A0I'll handle the mdadm update.
>
> Alright, then. =A0With Jeff's reluctant ack and scheduled mdadm updat=
e,
> I guess this one can go upstream. =A0I'll refresh the patchset and
> repost. =A0Umm... BTW do I have Heinz's mail address right?

Heinz, here is the whole thread:

http://marc.info/?t=3D123345711600004&r=3D1&w=3D2
