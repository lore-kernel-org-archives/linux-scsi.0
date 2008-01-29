From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [BUG] 2.6.24-git usb reset problems
Date: Tue, 29 Jan 2008 22:26:48 +0200
Message-ID: <479F8C08.2060207@panasas.com>
References: <20080129141108.GV15220@kernel.dk> <200801291531.39825.oliver@neukum.org> <20080129143109.GW15220@kernel.dk> <20080129183910.GI15220@kernel.dk> <20080129191024.GO14375@one-eyed-alien.net> <1201635195.3069.36.camel@localhost.localdomain> <20080129193520.GQ15220@kernel.dk> <20080129194543.GR15220@kernel.dk> <479F856C.4090900@panasas.com> <479F880F.20709@panasas.com> <20080129201328.GZ15220@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080129201328.GZ15220-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Matthew Dharm <mdharm-kernel-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Oliver Neukum <oliver-GvhC2dPhHPQdnm+yROfE0A@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 29 2008 at 22:13 +0200, Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Jan 29 2008, Boaz Harrosh wrote:
>>> Ok this is not in Linus tree is it? Hence I did not have that failure.
>>>
>>> Boaz
>>>
>>>
>> actually James bidi tree has a fix for this in the scsi_data_buffer patch.
>>
>> what you sent is not enough there are other places. look at this patch I
>> sent to the list.
>>
>> http://www.spinics.net/lists/linux-scsi/msg21938.html
> 
> Hard to compare, since its on different bases.
Yes in this patchset I have taken your sg branch at the time, and
rebased it ontop of scsi_data_buffer patch. Because I felt that
it is more natural for this patch to come after the scsi total
cleanup that is scsi_data_buffer. Then the extraction to sg_table
is simple and trivial.

What I meant to point out with this patch is that all the exact same
places that are touched there should be fixed when moving to sg_table.

Look at it. It is a revised version of your patch.

> 
>> Could we take the 2 SG patches and submit them through the scsi
>> bidi tree? It is much more natural to have them in one tree as one
>> patchset then try coordinate with git-merge. Actually if you look at it,
>> the biggest change is to SCSI. So I think it is more natural this way
> 
> What 2 sg patches do you mean?
> 

I mean the patches that where in sg branch of the linux-block tree, But
I see that it is now to late, and that they are in Linus already

James the most simple is to submit the scsi_data_buff patch that fixes
all these places. If not do you want that I send in fixes?

Boaz
