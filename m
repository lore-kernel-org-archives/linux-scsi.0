From: John Hughes <john@Calva.COM>
Subject: Re: ses enclosure stuff not working with Promise Vtrak J610S JBOD
Date: Wed, 04 Nov 2009 17:12:23 +0100
Message-ID: <4AF1A7E7.7070307@Calva.COM>
References: <4AF17AD3.6060909@Calva.COM>	 <1257348128.2697.29.camel@mulgrave.site>  <4AF1A38E.3000009@Calva.COM> <1257350834.2697.52.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oceanic.CalvaEDI.COM ([81.252.197.184]:35921 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbZKDQMU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2009 11:12:20 -0500
In-Reply-To: <1257350834.2697.52.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> Could you tell me what the enclosure page 0 (supported diagnostic pages)
> and page 10 (additional information page that allows us to do the
> matching) say?  I suspect the enclosure either doesn't support the page
> needed for the matching or there's some problem with the way the
> information is encoded.
>   
Ok, here we go.   (I wonder whether the "<<<additional: response too 
short>>>" at the end of page 10 has something to do with the problem).

# sg_ses -p 0 /dev/sg17
  PROMISE   3U-SAS-16-D BP    0107
    enclosure services device
Supported diagnostic pages:
  Supported diagnostic pages [0x0]
  Configuration (SES) [0x1]
  Enclosure status/control (SES) [0x2]
  Threshold In/Out (SES) [0x5]
  Enclosure busy (SES-2) [0x9]
  Additional (device) element status (SES-2) [0xa]

# sg_ses -p 10 /dev/sg17
  PROMISE   3U-SAS-16-D BP    0107
    enclosure services device
Additional (device) element status diagnostic page:
  generation code: 0x0
  Element type: Array device, subenclosure id: 0
    element index: 0 [0x0]
    Transport protocol: SAS
    number of phys: 1, not all phys: 1, bay number: 1
    phy index: 0
      device type: end device
      initiator port for:
      target port for: SSP
      attached SAS address: 0x5000155359a7723f
      SAS address: 0x5000c50012b081fd
      phy identifier: 0x0
    element index: 1 [0x1]
    Transport protocol: SAS
    number of phys: 1, not all phys: 1, bay number: 2
    phy index: 0
      device type: end device
      initiator port for:
      target port for: SSP
      attached SAS address: 0x5000155359a7723f
      SAS address: 0x5000c50012b07c69
      phy identifier: 0x0
    element index: 2 [0x2]
    Transport protocol: SAS
    number of phys: 1, not all phys: 1, bay number: 3
    phy index: 0
      device type: end device
      initiator port for:
      target port for: SSP
      attached SAS address: 0x5000155359a7723f
      SAS address: 0x5000c50012af7b95
      phy identifier: 0x0
    element index: 3 [0x3]
    Transport protocol: SAS
    number of phys: 1, not all phys: 1, bay number: 4
    phy index: 0
      device type: end device
      initiator port for:
      target port for: SSP
      attached SAS address: 0x5000155359a7723f
      SAS address: 0x5000c50012ac04dd
      phy identifier: 0x0
    element index: 4 [0x4]
    Transport protocol: SAS
    number of phys: 1, not all phys: 1, bay number: 5
    phy index: 0
      device type: no device attached
      initiator port for:
      target port for: SATA_device
      attached SAS address: 0x5000155359a7723f
      SAS address: 0x5000155359a77204
      phy identifier: 0x0
    element index: 5 [0x5]
    Transport protocol: SAS
    number of phys: 1, not all phys: 1, bay number: 6
    phy index: 0
      device type: end device
      initiator port for:
      target port for: SSP
      attached SAS address: 0x5000155359a7723f
      SAS address: 0x5000c50012b020a9
      phy identifier: 0x0
    element index: 6 [0x6]
    Transport protocol: SAS
    number of phys: 1, not all phys: 1, bay number: 7
    phy index: 0
      device type: end device
      initiator port for:
      target port for: SSP
      attached SAS address: 0x5000155359a7723f
      SAS address: 0x5000c50012b069c1
      phy identifier: 0x0
    element index: 7 [0x7]
    Transport protocol: SAS
    number of phys: 1, not all phys: 1, bay number: 8
    phy index: 0
      device type: end device
      initiator port for:
      target port for: SSP
      attached SAS address: 0x5000155359a7723f
      SAS address: 0x5000c50012b0658d
      phy identifier: 0x0
    element index: 8 [0x8]
      flagged as invalid (no further information)
    element index: 9 [0x9]
    Transport protocol: SAS
    number of phys: 1, not all phys: 1, bay number: 10
    phy index: 0
      device type: end device
      initiator port for:
      target port for: SSP
      attached SAS address: 0x5000155359a7723f
      SAS address: 0x5000c50012b05a69
      phy identifier: 0x0
    element index: 10 [0xa]
    Transport protocol: SAS
    number of phys: 1, not all phys: 1, bay number: 11
    phy index: 0
      device type: end device
      initiator port for:
      target port for: SSP
      attached SAS address: 0x5000155359a7723f
      SAS address: 0x5000c50012b071e5
      phy identifier: 0x0
    element index: 11 [0xb]
    Transport protocol: SAS
    number of phys: 1, not all phys: 1, bay number: 12
    phy index: 0
      device type: end device
      initiator port for:
      target port for: SSP
      attached SAS address: 0x5000155359a7723f
      SAS address: 0x5000c50012b0815d
      phy identifier: 0x0
    element index: 12 [0xc]
      flagged as invalid (no further information)
    element index: 13 [0xd]
    Transport protocol: SAS
    number of phys: 1, not all phys: 1, bay number: 14
    phy index: 0
      device type: end device
      initiator port for:
      target port for: SSP
      attached SAS address: 0x5000155359a7723f
      SAS address: 0x5000c50012a76085
      phy identifier: 0x0
    element index: 14 [0xe]
    Transport protocol: SAS
    number of phys: 1, not all phys: 1, bay number: 15
    phy index: 0
      device type: end device
      initiator port for:
      target port for: SSP
      attached SAS address: 0x5000155359a7723f
      SAS address: 0x5000c50012b07459
      phy identifier: 0x0
    element index: 15 [0xf]
    Transport protocol: SAS
    number of phys: 1, not all phys: 1, bay number: 16
    phy index: 0
      device type: end device
      initiator port for:
      target port for: SSP
      attached SAS address: 0x5000155359a7723f
      SAS address: 0x5000c50012a82989
      phy identifier: 0x0
  Element type: Enclosure services controller electronics, subenclosure id: 0
    element index: 38 [0x26]
    Transport protocol: SAS
    number of phys: 24
    phy index: 0
      phy identifier: 0x50
      connector element index: 21, other element index: 83
      SAS address: 0x59a7723f28002a01
    phy index: 1
      phy identifier: 0x2c
      connector element index: 46, other element index: 3
      SAS address: 0x3004320534063607
    phy index: 2
      phy identifier: 0x38
      connector element index: 58, other element index: 9
      SAS address: 0x3c0a3e0b400c420d
    phy index: 3
      phy identifier: 0x44
      connector element index: 70, other element index: 15
      SAS address: 0x48ff49ff4aff4bff
    phy index: 4
      phy identifier: 0x4c
      connector element index: 77
      SAS address: 0x4eff4fff163e0027
    phy index: 5
      phy identifier: 0x18
      connector element index: 0, other element index: 0
      SAS address: 0x5000155359a7733f
    phy index: 6
      phy identifier: 0x29
      connector element index: 43, other element index: 1
      SAS address: 0x2d022f0331043305
    phy index: 7
      phy identifier: 0x35
      connector element index: 55, other element index: 7
      SAS address: 0x39083b093d0a3f0b
    phy index: 8
      phy identifier: 0x41
      connector element index: 67, other element index: 13
      SAS address: 0x450e470f50ff51ff
    phy index: 9
      phy identifier: 0x52
      connector element index: 83
      SAS address: 0x54ff55ff56ff57ff
    phy index: 10
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 11
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 12
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 13
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 14
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 15
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 16
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 17
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 18
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 19
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 20
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 21
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 22
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 23
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    element index: 39 [0x27]
    Transport protocol: SAS
    number of phys: 24
    phy index: 0
      phy identifier: 0x50
      connector element index: 21, other element index: 83
      SAS address: 0x59a7733f29002b01
    phy index: 1
      phy identifier: 0x2d
      connector element index: 47, other element index: 3
      SAS address: 0x3104330535063707
    phy index: 2
      phy identifier: 0x39
      connector element index: 59, other element index: 9
      SAS address: 0x3d0a3f0b410c430d
    phy index: 3
      phy identifier: 0x45
      connector element index: 71, other element index: 15
      SAS address: 0x50ff51ff52ff53ff
    phy index: 4
      phy identifier: 0x54
      connector element index: 85
      SAS address: 0x56ff57ff00000000
    phy index: 5
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 6
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 7
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 8
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 9
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 10
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 11
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 12
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 13
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 14
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 15
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 16
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 17
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 18
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 19
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 20
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 21
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 22
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    phy index: 23
      phy identifier: 0x0
      connector element index: 0, other element index: 0
      SAS address: 0x0000000000000000
    <<<additional: response too short>>>




