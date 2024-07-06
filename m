Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3946A33A;
	Sat,  6 Jul 2024 10:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720260555; cv=none; b=sWXBox20w4MPJ9Gj38jWw2q39E/vwMteUG9bmM3KKJLFW+zTNbE5v0Zgl/CbP0hM7BhKzXDv5LV6MNGvoyWvQ6BlVSuCMArr2c8Q1EkSp4p1MP8Lr+xzUzXAKv/chiZ298EQHTXKWGOyVzuuj5ilIVzpf+auKxXcBvv9DlAwifA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720260555; c=relaxed/simple;
	bh=XpTOeHbVyo9I0mYSo+5dvjfIX9h2N5a95RkXiVk9Y98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CdJjedkH2m6QeQ0oSs5q6UgVQFG+QHyFsYgPuYraaiqhdOYFrtQoQYVzAa5vS7rEILVLkIIEntrj3RTBelPLDlSHEcDuvJQURB8iV4RFjcV9RmYMbMhEmWV8v04q5HlHXrNQkio+ntxZs4kaqMFZUTlkzD4XImHba0f5rTC8qEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kY9qSRVP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kY9qSRVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B403C2BD10;
	Sat,  6 Jul 2024 10:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720260554;
	bh=XpTOeHbVyo9I0mYSo+5dvjfIX9h2N5a95RkXiVk9Y98=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kY9qSRVPnVB9fXqof8VQV50faf/ermA5j4bRkT1he721bozymAbr+FGhfsyyUd4ee
	 XAJyTQ1UpjR4tdJn6PMYV5RbHPfL4aQ0nhGZRrEMxXtIrkWyuJ2Ut6L9nZDunExIYV
	 NBaffXeLqibfLAVNRTd54vx7PLnZFbilyLieDymw=
Date: Sat, 6 Jul 2024 12:09:12 +0200
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Aditya Garg <gargaditya08@live.com>
Cc: "oneukum@suse.com" <oneukum@suse.com>,
	"stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
	Kerem Karabay <kekrby@gmail.com>,
	Orlando Chamberlain <orlandoch.dev@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"usb-storage@lists.one-eyed-alien.net" <usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH v2 2/2] scsi: usb: uas: Implement the new shutdown
 callback
Message-ID: <2024070603-deniable-slang-f93d@gregkh>
References: <A6C4519F-852E-4B5C-B791-7396B515B8A6@live.com>
 <A53C580E-C0CC-42AA-B50B-F1B8A5756C9F@live.com>
 <BAC247FF-CDA3-4C34-A9CC-A429E3AD13C3@live.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAC247FF-CDA3-4C34-A9CC-A429E3AD13C3@live.com>

On Sat, Jul 06, 2024 at 10:01:38AM +0000, Aditya Garg wrote:
> From: Kerem Karabay <kekrby@gmail.com>
> 
> This patch implements the new shutdown callback method added to
> usb_driver on the UAS driver.

Again, says what it does, but not why.

