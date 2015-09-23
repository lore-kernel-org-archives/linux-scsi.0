From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: Limit max concurrent sessions
Date: Wed, 23 Sep 2015 16:20:01 +0200
Message-ID: <5602B511.8020502@assyoma.it>
References: <554A34F3.5080507@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mr002msb.fastweb.it ([85.18.95.86]:34959 "EHLO
	mr002msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbbIWOZ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Sep 2015 10:25:26 -0400
Received: from ceres.assyoma.it (93.63.55.57) by mr002msb.fastweb.it (8.5.140.03)
        id 55C56E6502077AD7 for linux-scsi@vger.kernel.org; Wed, 23 Sep 2015 16:20:02 +0200
In-Reply-To: <554A34F3.5080507@assyoma.it>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: g.danti@assyoma.it

Hi all,
anyone with some ideas / infos ?

Thanks.

On 06/05/15 17:36, Gionatan Danti wrote:
> Hi all,
> I would like to understand if, and how to, limit the maximum number of
> simultaneous connections to a specific LUN, both with the old iSCSI
> stack (tgtadmin and friends) and the new one (targetcli and the likes).
>
> I am exporting a LUN with a general purpose filesystem (non cluster
> aware) and I would be 100% sure that only a single machine at a time can
> mount it.
>
> At the moment, I protected the iSCSI LUN with both an IP-based access
> list and a username/password combo, but hard limiting the maximum number
> of connections opened against it to 1 (one) would be a nice thing...
>
> As I have mixed RHEL 6 and 7 environment, I am interested in how to do
> that on both the old and new iSCSI stack.
>
> Thank you,
> regards.
>

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
