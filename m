From: Michael Clark <michael@metaparadigm.com>
Subject: Re: ANNOUNCE: saftemon - SCSI Enclosure monitor for linux
Date: Wed, 17 Apr 2002 23:16:16 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CBD91C0.6050905@metaparadigm.com>
References: <71714C04806CD51193520090272892170452B669@ausxmrr502.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Matt_Domsch@Dell.com
Cc: linux-scsi@vger.kernel.org

Matt_Domsch@Dell.com wrote:

>>saftemon - SCSI Enclosure monitor for SAFTE enclosures
>>
>>This is the initial public release so i'd be keen to receive any
>>feedback or compatibility testing. It has currently only been
>>tested on nStor external enclosures and Intel internal SAFTE
>>capable enclosures.
>>
>
>Works beautifully on my Dell PowerEdge 2400 internal SAFTE backplane.  We'll
>give it a shot on our other SAFTE capable enclosures in the coming weeks. 
>
You may have some trouble with some RAID HBAs that don't pass through
non disk devices (or maybe just processor devices). I have some Mylex HBAs
that I can't see the SAFTE processors through although my AMI Megaraids can.

~mc

