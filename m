From: Michael Clark <michael@metaparadigm.com>
Subject: Re: ANNOUNCE: saftemon - SCSI Enclosure monitor for linux
Date: Thu, 18 Apr 2002 13:18:06 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CBE570E.10302@metaparadigm.com>
References: <Pine.BSF.4.21.0204172122300.80194-100000@beppo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: mjacob@feral.com
Cc: Matt_Domsch@Dell.com, linux-scsi@vger.kernel.org

Matthew Jacob wrote:

>No- SAF-TE was what an *early* version of SES looked like. Then it went it's
>own way. Currently there is a bunch of SAF-TE chips out there (e.g. GEM-I and
>GEM-II), but the spec is no longer owned by anyone and www.safte.org
>disappeared over two years ago, so the ability to even find the spec is
>limited to finding those who had downloaded both the .doc and the addendum.
>

Okay. Yeah, for a while they weren't accessible and I initially worked off a
google cached copy. The SAF-TE spec and addendum can now be found here:

    http://www.nstor.com/white_papers.cfm

>
>Somebody out there correct me if I'm wrong.
>
>At any rate, you *can* emulate SAF-TE within SES. In fact, it's better to
>create an SES driver and then map SAF-TE into it (which is what I did for
>Solaris && *BSD). There are a couple of global status items that don't map
>easily- and the one wierd thing is to map the overtemp bits (all 17 of them)  
>into SES temperature elements. Plus the conversion of SAF-TE temp ranges for
>SAF-TE temp elements into SES temperature elements (different ranges). What a
>PITA.
>

Yes, would make sense to do it that way. The SAF-TE specific code in 
saftemon
is mostly limited to a handful of functions that probe the device and 
populate
the enclosure information structures. All the state information 
bitfields are
currently SAF-TE, although as you say, it could be changed to SES and 
make the
safte probing routines do the conversion.

Somebody with an SES enclosure may want to do this.
(unless someone wants to donate one to me - full of disks of course ;).

I can probably make some changes like changing safte_device_t to 
enclosure_t,
etc. to make the code a bit more generic. When I get time, i'll take a look
at that.

~mc

