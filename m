Return-Path: <SRS0=vnQa=3L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A267C2D0DB
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 15:54:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D3F221835
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 15:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579708460;
	bh=5ANYAe8H7x9Ef6asGH9m5aEld7J9uE/DB5mYKoBzAKc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=pqBv/lUbF6wzs2R0T/BDZb8TStGrxCyBAnD1YdFvrFWqxkbDJq9SpbGmkpIEdhcIc
	 Qg+WNiacckNNaE16gnFNpR2ZbHkM5gyPEAuJ6z3SFPWG5UEttLqaOgHS2Yzy0MjW5z
	 e5GfJ3dANcA5evxrjBlml6TJZoS1I41Agsd7Z38c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgAVPyS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 10:54:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:39956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgAVPyR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Jan 2020 10:54:17 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03AAD21835;
        Wed, 22 Jan 2020 15:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579708457;
        bh=5ANYAe8H7x9Ef6asGH9m5aEld7J9uE/DB5mYKoBzAKc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kxsLCCxsXu4bIIFFC5KJqmps4FD4NrXBn6VPVtwRB4v98cLirPozE//RzBDM9Ec51
         zNIcgdSzR54vnwkT7j+zUEu+cb2iDG5hXta6mSAmAL8b0UZRTZeWHQMMdWFsg/MGlM
         ZpvMhA9vVxCYXHfYUdRYU7j61tZrxv/zQn0dPNDk=
Date:   Wed, 22 Jan 2020 07:54:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kalderon <michal.kalderon@marvell.com>
Cc:     <ariel.elior@marvell.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH net-next 13/14] qed: FW 8.42.2.0 debug features
Message-ID: <20200122075416.608979b2@cakuba>
In-Reply-To: <20200122152627.14903-14-michal.kalderon@marvell.com>
References: <20200122152627.14903-1-michal.kalderon@marvell.com>
        <20200122152627.14903-14-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 22 Jan 2020 17:26:26 +0200, Michal Kalderon wrote:
> Add to debug dump more information on the platform it was collected
> from (kernel version, epoch, pci func, path id).

Kernel version and epoch don't belong in _device_ debug dump.
