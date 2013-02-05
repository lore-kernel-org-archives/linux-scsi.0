From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [LSF/MM TOPIC] Thin provisioning SOFT_THRESHOLD error handling
Date: Mon, 04 Feb 2013 21:22:45 -0500
Message-ID: <51106CF5.4020807@suse.com>
References: <510784DE.3000509@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <510784DE.3000509@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: lsf-pc@lists.linux-foundation.org, Linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/29/13 3:14 AM, Hannes Reinecke wrote:
> Hi all,
> 
> Thin-provisioned devices have the ability to set a 'soft
> threshold', which is triggered if the real free space for this
> device is beyond this mark.
> 
> The intention behind this is to allow the system to induce some
> garbage collection with possibly freeing up unused space.
> 
> Initially it would be possible to execute garbage collection on 
> filesystems (eg for btrfs).
> 
> However, as this concept applies to other areas within the kernel 
> (like dm-thinp or even btrfs itself) it might be an idea to have a
> general mechanism / error handling etc in place.
> 
> I would like to discuss at LSF the possible implementations and
> handling mechanism for this kind of failure scenarios.

I'd be really interested in discussion on this as well. I can see a
bunch of different uses for this.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJREGz0AAoJEB57S2MheeWy7j8QAKzFRhdtXXMjU/x/S2HZ9TO6
BZCCPN9b5TmUKFWfnSxJ62AqcE0rHkUkTvKIHXdGXUgGP//YR2xkX82xDTtQCUCD
iCj+Dq7MlEFblFLUOC/EjYN5dv4DmGlYxmDrkvVjZcBURbMzijtKik0GqEZ/SI5E
XtilHxyoppdQDvR64g+Tlbwfmp9pyZjBY9in2JZVw7g5oWzrUw+IWZO9S06MUFUc
ZZwdzauYi1y6rDlS9fT9PtbLpCOc0UuUFTvkc1zeKMhSZJSxcIuixMNvR1LnGpZB
XxbpNLKr9O6+bb5/KycjKgbGLDWXXxYX2/5RZ3nNZCxP3FSgnY9lL+9zcgP2FY4D
XcOeif0AJQQEmd2NSl9KjBWzk3LFgelNEz2rsYedSN6CZjOLTK2jpllQM5+h5X0q
FPs3R1sh2OQ62P84JEFD821Teo3Aj3GlkMmIaUsMqaYQi/UZ4p4NVb9U7eExBA0Z
EhV34hjLqs7PVHPajk84gWc291cgXaQj7NH9Ga/7oqBVVF3ouRGDbYKEX2riJMk7
p72sEzi/xT/uGU+lXUDoFr4JUZWTEaKjjbZbN2/UTk+G+MZiwi0Xy6i2YFby9UuH
SuQET55bJHOjzwPbb5uW7WSbJQLmIxp072aA3cK27E7MT2G4RKuVnpj8MlboraDT
uZQPxtndwpC58nWtHHdu
=HI+u
-----END PGP SIGNATURE-----
