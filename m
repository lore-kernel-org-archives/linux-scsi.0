From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] sd.c fixes applied incorectly to 2.4.19-preXX
Date: Tue, 16 Apr 2002 08:08:00 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200204161408.g3GE80990144@aslan.scsiguy.com>
References: <20020416055820.GF12608@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Your message of "Tue, 16 Apr 2002 07:58:20 +0200."
             <20020416055820.GF12608@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi@vger.kernel.org, Alan Cox <alan@redhat.com>

>On Mon, Apr 15 2002, Justin T. Gibbs wrote:
>> Marcelo,
>> 
>> Looking at the latest version of your tree via bitkeeper, it
>> seems that the wrong patch has been applied to sd.c.  In its
>> current state, the disk driver will fail to act upon any sense
>> data returned by the low level controller.  The following patch
>> restores correct behavior.
>
>Justin,
>
>Noticed this myself the other day... I don't think they were applied
>incorrectly, your 2.4.18 patch is buggy while your 2.4.17 version is
>quite ok.

There were two patches posted to the list about this issue.  The first
had this bug.  The second did not.  It does look like the merge of this
correction didn't make it into my 2.4.18 tree at the time I generated
the 2.4.18 patch set for the 6.2.5 release.  I have corrected that
patch set.

--
Justin
