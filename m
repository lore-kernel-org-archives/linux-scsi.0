From: Chris Leech <christopher.leech@intel.com>
Subject: Re: [Open-FCoE] [PATCH 1/3] 24-bit types: typedef and macros for
 accessing 3-byte arrays as integers
Date: Wed, 10 Sep 2008 10:45:13 -0700
Message-ID: <48C807A9.60509@intel.com>
References: <20080905165732.16689.50256.stgit@localhost.localdomain>		<20080910140712.GA12280@infradead.org>	<1221061241.27385.14.camel@norville.austin.ibm.com> <48C7F4EC.1080709@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:29248 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbYIJRpP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2008 13:45:15 -0400
In-Reply-To: <48C7F4EC.1080709@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Chris Leech wrote:
> Dave Kleikamp wrote:
>> @@ -62,7 +60,7 @@ struct timestruc_t {
>>   */
>>  typedef struct {
>>  	unsigned len:24;
>> -	unsigned off1:8;
>> +	u8 off1;
>>  	u32 off2;
>>  } lxd_t;
> 
> Shouldn't len here be changed to a __le24?  I think this just changed
> the size of lxd_t by a byte.

Never mind, I see that it's a host order field.  And presently surprised
to see that gcc combines the 24-bit bitfield with the following u8.

Chris
