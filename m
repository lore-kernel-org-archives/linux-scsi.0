From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] SCSI Core cmd allocation 3/3
Date: Mon, 13 Jan 2003 14:16:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E2310A0.8080308@splentec.com>
References: <3E1A2140.3000408@splentec.com> <20030111180355.B2225@infradead.org> <3E22F369.5080209@splentec.com> <20030113175948.A27650@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> 
> Well, where do you actually _need_ scsi_get_command(), that's the question.
> 
> I see the purpose, but I don't see it actually used.

The scsi devices discovery code *may* use it.

> Go and program in Smalltalk if you're a OOP fanatic.  Even if the kernel

I've had my share with C++.  You didn't have to be ironic, I was trying
to convey a point, which you're shooting down before even considering it.

> uses OOP paradigms where they are useful it uses procedural interfaces
> where they make more sense.  And in thjis case the OOP abstraction don't buy
> us anything.

The improperly conjucated phrase ``... don't buy us anything'' is
over-used in linux-kernel; why do it here as well?

>>It is my belief that such a struct will make things cleaner and clearer.
> 
> 
> But it's not a paradigm used in the linux kernel usually.

``There's always a first time.'' -- anonymous

If a global variable is used in a couple of files, belonging
to the same functionality, providing a unified service, and if
there's more than one of them, then they are better organized
as such as I've outlined.

In fact I'd argue that OOP is used exclusively *everywhere* in kernel
programming and specifically in the Linux kernel. It's an integral
part of organization of data, manipulators and ownership.
You name it, *anything* -- it's OOP. Files, filesystems, devices,
networking, etc, etc, etc.

> Kernel style is not just K&R.  i.e. your function descriptions should be
> converted to the extractable kernel-doc comments

/* fn_name: comment
    more comment
*/

This is the style K&R1 uses, from which I learned C, many, many years
ago...

I also thought that the kernel comment parser could recognize such
patterns, as they are not that hard to parse.

> and stuff like:
> 
> +       if (!dev) return NULL;
> +       if (!dev->host) return NULL;
> 
> doesn't even seem to be K&R to me :)

Christoph, please, this is an *inline* function -- it doesn't have to be
20 lines if it can be 10.

-- 
Luben



