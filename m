From: "Rustad, Mark D" <mark.d.rustad@intel.com>
Subject: Re: [PATCH] scsi: Resolve some missing-field-initializers warnings
Date: Fri, 17 Oct 2014 22:44:36 +0000
Message-ID: <C69957AC-DB35-467C-85B1-091B740C74C9@intel.com>
References: <1413293933-31164-1-git-send-email-jeffrey.t.kirsher@intel.com>,<20141017132611.GM16538@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:65341 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbaJQWoi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Oct 2014 18:44:38 -0400
In-Reply-To: <20141017132611.GM16538@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The warning appears in W=2 builds. I had another way to silence it by using diagnostic control macros, but those macros were not accepted. Using a single designated initialization also silences it.

Sent from my iPhone

> On Oct 17, 2014, at 8:26 AM, "Christoph Hellwig" <hch@infradead.org> wrote:
> 
>> On Tue, Oct 14, 2014 at 06:38:53AM -0700, Jeff Kirsher wrote:
>> From: Mark Rustad <mark.d.rustad@intel.com>
>> 
>> Resolve some missing-field-initializers warnings by using
>> designated initialization.
> 
> What tool is warning about these?  This construct is perfectly valid C.
