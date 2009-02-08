From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] libosd: Fix NULL dereference BUG when target is none
 OSD conformant
Date: Sun, 08 Feb 2009 18:00:11 +0200
Message-ID: <498F018B.5020003@panasas.com>
References: <498EE637.3030800@panasas.com> <498EE789.2010507@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:28979 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751484AbZBHQAS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Feb 2009 11:00:18 -0500
In-Reply-To: <498EE789.2010507@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fuerst Lars <lars.fuerst@thomson.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

Boaz Harrosh wrote:
> Boaz Harrosh wrote:
>> Very old OSC's Target had a BUG in the Get/Set attributes where
>> it was looking in the wrong places for attribute lists length.
>> If used with the open-osd initiator, the initiator would dereference
>> a NULL pointer when retrieving system_information attributes.
>>
>> Checks are added if retrieval of each attributes was successful
>> before accessing them.
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> ---
> 
> Lars I will need your Tested-by: ... here
> I did not manage to run with your version of the target. It might crash
> farther on now.
> 

OK That patch will not work for you. I had another one in Q before that
one. I've rebased so it will apply over current scsi-misc.

Sent as reply to first patch.

Sorry for the noise

Boaz
