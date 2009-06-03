From: "Zou, Yi" <yi.zou@intel.com>
Subject: RE: Question regarding protocol specific mtu for FCoE
Date: Wed, 3 Jun 2009 13:43:02 -0700
Message-ID: <7C88852EF6F99F4EB538472FCFEBE2223A7E7050@orsmsx509.amr.corp.intel.com>
References: <7C88852EF6F99F4EB538472FCFEBE2223A7E6F45@orsmsx509.amr.corp.intel.com>
	 <4A26BAF7.3070301@hp.com>
	 <7C88852EF6F99F4EB538472FCFEBE2223A7E6FBD@orsmsx509.amr.corp.intel.com>
 <1244057245.3191.17.camel@achroite>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:33402 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbZFCUnO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 16:43:14 -0400
In-Reply-To: <1244057245.3191.17.camel@achroite>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Rick Jones <rick.jones2@hp.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Leech, Christopher" <christopher.leech@intel.com>, "Dev, Vasu" <vasu.dev@intel.com>, "Love, Robert W" <robert.w.love@intel.com>, "Ma, Steve" <steve.ma@intel.com>, "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>, "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>

>On Wed, 2009-06-03 at 12:16 -0700, Zou, Yi wrote:
>[...]
>> FCoE is on L2 layer, no path specific MTU, everything goes out as
>> whatever mtu known to the nic. Since the nic is expected to be used
>for
>> converged traffic involving multiple traffic types, e.g. LAN, FCoE, I
>> was wondering if it makes sense to have the additional MTU.
>Essentially,
>> the nic driver will be able to setup via netdev for different MTUs
>for
>> converged traffic.
>
>Wouldn't you use separate VLANs for FCoE and other traffic?  So maybe
>we
>should allow for per-VLAN rather than per-protocol MTU.
>
>Ben.
>
>From what I can tell, you will not be able to set vlan device's MTU
that is larger than the real_dev->mtu, as in vlan_dev_change_mtu().

Thanks.

yi

