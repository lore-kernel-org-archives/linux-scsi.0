From: Douglas Gilbert <dougg@torque.net>
Subject: Re: 2.5.56-mm1 fails to detect cd burner
Date: Mon, 31 Mar 2003 15:50:54 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E87D73E.5030107@torque.net>
References: <20030311063627.GJ1399@holomorphy.com> <20030311160358.GN465@holomorphy.com> <3196100000.1047914843@aslan.scsiguy.com> <20030318211357.GA1232@holomorphy.com> <20030329134951.GJ13178@holomorphy.com> <20030330212439.GU13178@holomorphy.com> <58090000.1049063164@caspian.scsiguy.com> <20030331052947.GW13178@holomorphy.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: William Lee Irwin III <wli@holomorphy.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-scsi@vger.kernel.org

William Lee Irwin III wrote:
> On Sat, Mar 29, 2003 at 05:49:51AM -0800, William Lee Irwin III wrote:
> 
>>>Okay, it's still burning coasters as of 2.5.65-mm1
>>
> 
> On Sun, Mar 30, 2003 at 10:26:04PM +0000, Justin T. Gibbs wrote:
> 
>>This is not an informative bug report.  Can you share any other details?
>>Are any errors reported?
> 
> 
> There are no ostensible errors. I logged the whole cdrecord session
> (and used axboe's "special" cdrecord version) and have that, but
> there's nothing obviously going wrong anywhere in it.

William,
Perhaps you could try an older version of cdrecord
that uses the sg interface. That way we may be able to
isolate the problem (and you may even get a useful
CD-R burnt).

Does that "special" version of cdrecord interface to the
kernel via the CDROM_PACKET or the SG_IO ioctl?

When I connected my Yamaha 4416S burner to an Adaptec
19160 on the 2.5.65 kernel it locked up in the scan
as you reported. My Tekram 390U3W with the sym53c8xx_2
driver didn't have this problem. I haven't had the need
to burn a CD-R recently. I have downloaded Justin's
latest aic7xxx driver but haven't loaded it yet.

Doug Gilbert


