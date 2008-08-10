From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
Date: Sun, 10 Aug 2008 14:34:17 +0800
Message-ID: <E1KS4VN-0000v1-00@gondolin.me.apana.org.au>
References: <20080809.224725.130946315.davem@davemloft.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:50030 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752133AbYHJGfF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Aug 2008 02:35:05 -0400
In-Reply-To: <20080809.224725.130946315.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: rdreier@cisco.com, jgarzik@pobox.com, swise@opengridcomputing.com, divy@chelsio.com, kxie@chelsio.com, netdev@vger.kernel.org, open-iscsi@googlegroups.com, michaelc@cs.wisc.edu, daisyc@us.ibm.com, wenxiong@us.ibm.com, bhua@us.ibm.com, dm@chelsio.com, leedom@chelsio.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
>
>> We already support offloads that break other features, eg large receive
>> offload breaks forwarding.  We deal with it.
> 
> We turn it off.  If I want to shape or filter one of these iSCSI
> connections can we turn it off?

Actually one of my TODO items is to restructure software LRO
so that we preserve the original packet headers while aggregating
the packets.  That would allow us to easily refragment them on
output for forwarding.

In other words LRO (at least the software variant) is not
fundamentally incompatible with forwarding.

I'd also like to encourage all hardware manufacturers considering
LRO support to provide a way for us to access the original headers
so that it doesn't have to be turned off for forwarding.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
