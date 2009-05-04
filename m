From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: [PATCHSET] block,scsi,libata: implement alt_size
Date: Mon, 4 May 2009 09:48:37 -0700
Message-ID: <e9c3a7c20905040948m572e23dj1aa197dbd20ff037@mail.gmail.com>
References: <1233456951-992-1-git-send-email-tj@kernel.org>
	 <49F902CF.7080307@garzik.org> <49F903DD.8040707@kernel.org>
	 <49FA0349.3090706@garzik.org>
	 <e9c3a7c20904301415t621670a0l1bd64c7d74d369f@mail.gmail.com>
	 <49FEA127.1000905@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <49FEA127.1000905@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Mauelshagen@redhat.com, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Mon, May 4, 2009 at 1:02 AM, Tejun Heo <tj@kernel.org> wrote:
>> Couldn't the "fix" also just be a note to users to disable ignore_hp=
a
>> if they notice that there raid arrays are not assembling correctly?
>
> I don't know. =A0If it doesn't work automatically, the solution reall=
y
> isn't worth much. =A0People generally don't (shouldn't need to) have =
any
> idea what HPA is. =A0It basically boils down to "Linux doesn't suppor=
t
> RAID". =A0:-)
>
> Maybe we should just put this issue to the rest and strongly advise
> people against BIOS raids.

That's a bit too far :-).  The real issue is that Linux is ignoring a
property of the platform.  To me ignoring HPA is like ignoring an e820
reserved memory region.  You might be able to get away with it
sometimes, but other times it breaks.

However, in the end I think having 'alt_size' available is a useful
mechanism for discovering and handling the ignore_hpa=3D1 case.   The
policy about when to trust it can be left to userspace.

Thanks,
Dan
