From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: scsi target, likely GPL violation
Date: Mon, 12 Nov 2012 09:41:49 +1100
Message-ID: <CAGRGNgWLE_hf41bz19H-QNJeEY7eGrq7vdEmx4AGFFJ3US6ENw@mail.gmail.com>
References: <509A915B.30105@redhat.com> <CAPoiz9wzx_NmuA1ty-U28MGiYr7XKCbDn_e0ZLmz=pNDCqwqFw@mail.gmail.com>
 <509B117A.6070708@genband.com> <509BE460.6010404@redhat.com>
 <1352405111.29589.476.camel@haakon2.linux-iscsi.org> <509C22B2.8010600@redhat.com>
 <1352426896.29589.512.camel@haakon2.linux-iscsi.org> <20121109110336.41833034@pyramind.ukuu.org.uk>
 <14c701cdc059$d6fd28b0$84f77a10$@rosenlaw.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <14c701cdc059$d6fd28b0$84f77a10$@rosenlaw.com>
Sender: linux-kernel-owner@vger.kernel.org
To: lrosen@rosenlaw.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kcopenhaver@choate.com, Richard Fontana <rfontana@redhat.com>, Marc Fleischmann <mwf@risingtidesystems.com>, Nicholas Bellinger <nab@risingtidesystems.com>, alan@lxorguk.ukuu.org.uk, agrover@redhat.com, bkuhn@sfconservancy.org, tytso@mit.edu
List-Id: linux-scsi@vger.kernel.org

Hi Lawrence,

On Mon, Nov 12, 2012 at 9:13 AM, Lawrence Rosen <lrosen@rosenlaw.com> wrote:
> Alan Cox wrote:
>> So either your work is truely not derivative of the kernel (which I find
>> wildly improbable) or you have a problem and since you are aware
>> of the complaints publically I guess probably a triple damages sized
>> problem. But that's one for your lawyers and whatever opinion they
>> have on the subject.
>
> Hi Alan and others,
>
> I've been advising Rising Tide Systems (RTS) in this matter. Please let me
> reassure you that RTS is acting on advice of counsel.

It's nice to hear from legal counsel on this matter.

I don't think that the *usage* of the kernel APIs is the biggest issue
here. There are many examples where proprietary code uses these APIs
and is not violating the GPL.

As I see it, one of the main concerns is because the proprietary and
in-kernel target systems are, from what I understand, quite similar,
there is the possibility that GPL licensed contributions to the
in-kernel target code may have "leaked" into to the proprietary code.
That said, proving this is a very difficult problem, but the question
must still be asked:

Can Rising Tide Systems assure us that there is no GPL licensed code
within their proprietary target code?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
