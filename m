From: John Hughes <john@Calva.COM>
Subject: Re: ses enclosure stuff not working with Promise Vtrak J610S JBOD
Date: Wed, 04 Nov 2009 16:53:50 +0100
Message-ID: <4AF1A38E.3000009@Calva.COM>
References: <4AF17AD3.6060909@Calva.COM> <1257348128.2697.29.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oceanic.CalvaEDI.COM ([81.252.197.184]:35573 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553AbZKDPxs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2009 10:53:48 -0500
In-Reply-To: <1257348128.2697.29.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2009-11-04 at 14:00 +0100, John Hughes wrote:
>   
>> No sign of an enclosure.
>>
>> I've tried with a Debian  2.6.26-2-xen-amd64 kernel, and a 2.6.31 I 
>> build myself.
>>
>> Any clues about what I should to to diagnose this problem?
>>     
>
> Tell me what disks you have first.  Currently the matching algorithm
> only works with SAS disks because we have no VPD translation for SATA.
> Hopefully I'll be getting a SATA device to put in an enclosure at some
> point, so I can play with this (at the moment I only have one SATA
> device and I'm using it for data storage ...).
>
> James
>
>
>   
All but one are SAS.

# lsscsi
[0:0:32:0]   enclosu DP       BACKPLANE        1.07  -       
[0:2:0:0]    disk    DELL     PERC 6/i         1.21  /dev/sda
[1:0:0:0]    cd/dvd  TEAC     DVD-ROM DV28SV   D.0J  /dev/sr0
[3:0:0:0]    disk    SEAGATE  ST373455SS       S528  /dev/sdb
[3:0:1:0]    disk    SEAGATE  ST373455SS       S528  /dev/sdc
[3:0:2:0]    disk    SEAGATE  ST373455SS       S528  /dev/sdd
[3:0:3:0]    disk    SEAGATE  ST373455SS       S528  /dev/sde
[3:0:4:0]    disk    ATA      ST3808110AS      J     /dev/sdf
[3:0:5:0]    disk    SEAGATE  ST373455SS       S528  /dev/sdg
[3:0:6:0]    disk    SEAGATE  ST373455SS       S528  /dev/sdh
[3:0:7:0]    disk    SEAGATE  ST373455SS       S528  /dev/sdi
[3:0:8:0]    disk    SEAGATE  ST373455SS       S528  /dev/sdj
[3:0:9:0]    disk    SEAGATE  ST373455SS       S528  /dev/sdk
[3:0:10:0]   disk    SEAGATE  ST373455SS       S528  /dev/sdl
[3:0:11:0]   disk    SEAGATE  ST373455SS       S528  /dev/sdm
[3:0:12:0]   disk    SEAGATE  ST373455SS       S528  /dev/sdn
[3:0:13:0]   disk    SEAGATE  ST373455SS       S528  /dev/sdo
[3:0:14:0]   enclosu PROMISE  3U-SAS-16-D BP   0107  -       
[4:0:0:0]    disk    SEAGATE  ST373455SS       S528  /dev/sdp
[4:0:1:0]    disk    SEAGATE  ST373455SS       S528  /dev/sdq
[4:0:2:0]    disk    SEAGATE  ST373455SS       S528  /dev/sdr
[4:0:3:0]    disk    SEAGATE  ST373455SS       S528  /dev/sds
[4:0:4:0]    disk    ATA      ST3808110AS      J     /dev/sdt
[4:0:5:0]    disk    SEAGATE  ST373455SS       S528  /dev/sdu
[4:0:6:0]    disk    SEAGATE  ST373455SS       S528  /dev/sdv
[4:0:7:0]    disk    SEAGATE  ST373455SS       S528  /dev/sdw
[4:0:8:0]    disk    SEAGATE  ST373455SS       S528  /dev/sdx
[4:0:9:0]    disk    SEAGATE  ST373455SS       S528  /dev/sdy
[4:0:10:0]   disk    SEAGATE  ST373455SS       S528  /dev/sdz
[4:0:11:0]   disk    SEAGATE  ST373455SS       S528  /dev/sdaa
[4:0:12:0]   disk    SEAGATE  ST373455SS       S528  /dev/sdab
[4:0:13:0]   disk    SEAGATE  ST373455SS       S528  /dev/sdac
[4:0:14:0]   enclosu PROMISE  3U-SAS-16-D BP   0107  -       


