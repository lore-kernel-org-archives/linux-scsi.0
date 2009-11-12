From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 10/17] hpsa:  Allow device rescan to be triggered via
 sysfs.
Date: Thu, 12 Nov 2009 14:51:24 -0800
Message-ID: <20091112145124.2e8ada8b.akpm@linux-foundation.org>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
	<20091111165114.17754.83467.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754747AbZKLWv1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Nov 2009 17:51:27 -0500
In-Reply-To: <20091111165114.17754.83467.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mikem@beardog.cce.hp.com

On Wed, 11 Nov 2009 10:51:14 -0600
"Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:

> Allow device rescan to be triggered via sysfs.

When adding a new userspace interface to the kernel, please fully
describe that interface in the changelog.

Is there somewhere where this should have been documented?
