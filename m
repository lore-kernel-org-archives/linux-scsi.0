From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 5/6] qla4xxx: Capture minidump for ISP82XX on firmware
 failure
Date: Fri, 04 May 2012 05:17:36 -0500
Message-ID: <4FA3ACC0.7000106@cs.wisc.edu>
References: <CBC9A645.E8BA%vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36445 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab2EDKRt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 May 2012 06:17:49 -0400
In-Reply-To: <CBC9A645.E8BA%vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, scsi <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Tej Parkash <tej.parkash@qlogic.com>, Shyam Sundar <shyam.sundar@qlogic.com>

On 05/04/2012 05:00 AM, Vikas Chaudhary wrote:
>> # echo 6 > /sys/class/scsi_host/host7/device/fw_dump

echo adds a newline by default. If you do echo -n it does not.

Does simple_strtol handle that but kstrol not handle it?

>>From above logs looks like sysfs attribute reading some extra garbage
>> >characters because of which
>> >'kstrtol()' fails but in same case 'simple_strtol()' works fine.
>> >
