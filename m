From: Alex Austin <aaustin@oceantechonline.com>
Subject: Re: Block-level access
Date: Thu, 1 Sep 2016 16:48:28 -0500
Message-ID: <CAGA4w7=eM9+sHMNaCXx5tXCEEyeJp0wb7ZqpAiuW35u+PEiSBw@mail.gmail.com>
References: <CAGA4w7nO+mrRwY-Rg0i_O8zBcrNeSS0KurLXN34duR2JJqvEmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAGA4w7nO+mrRwY-Rg0i_O8zBcrNeSS0KurLXN34duR2JJqvEmA@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

CC'ing linux-scsi and linux-block.

Also, please CC me in replies.

On Thu, Sep 1, 2016 at 4:43 PM, Alex Austin <aaustin@oceantechonline.com> wrote:
> Hello,
> What is the most performant way to directly interface with an attached hard
> drive? I've so far used read()/write() on /dev/sd_ but I find error handling
> exceedingly difficult, as I don't always even get errors reported, even if the
> open() call includes O_DIRECT. I've also used ioctl(SG_IO), but find that it's
> extremely slow due to the lack of queuing support in the API. Is there a
> mid-level API that will get me decent error handling while allowing command
> queuing, or do I just need to make multiple threads all doing separate SG_IO
> ioctls?
>
> Thank you,
> - Alex Austin
>
> --
> Intelligence is knowing that a tomato is a fruit; wisdom is knowing that it
> doesn't go in a fruit salad; charisma is selling a tomato-based fruit salad.



-- 
Intelligence is knowing that a tomoato is a fruit; wisdom is knowing
that it doesn't go in a fruit salad; charisma is selling a
tomato-based fruit salad.
