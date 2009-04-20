From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2] Evaluate TGPS setting for device handler detection
Date: Mon, 20 Apr 2009 15:51:18 -0500
Message-ID: <49ECE046.6060109@cs.wisc.edu>
References: <20090319080642.4815418C79D@pentland.suse.de> <1239899445.1196.12.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43026 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722AbZDTUvp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2009 16:51:45 -0400
In-Reply-To: <1239899445.1196.12.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@linux.vnet.ibm.com
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Peter Jones <pjones@redhat.com>

Chandra Seetharaman wrote:
>>  static const struct scsi_dh_devlist alua_dev_list[] = {
>> -	{"HP", "MSA VOLUME" },
>> -	{"HP", "HSV101" },
>> -	{"HP", "HSV111" },
>> -	{"HP", "HSV200" },
>> -	{"HP", "HSV210" },
>> -	{"HP", "HSV300" },
>> -	{"IBM", "2107900" },
>> -	{"IBM", "2145" },
>> -	{"Pillar", "Axiom" },
>> -	{"Intel", "Multi-Flex"},
>> -	{NULL, NULL}
>> +	{"", "", 3 },
>> +	{NULL, NULL, 0}
>>  };

Is this going to make problems for the what the module alias patches 
were trying to do?

Will userspace have to check for the mod alias stuff for scsi_dh_emc, 
scsi_dh_hp and scsh_dh_rdac, then for scsh_dh_alua does it check for the 
scsi devices sysfs tpgts file to see if ALUA is support?
