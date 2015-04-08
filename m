From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] target: Fix COMPARE_AND_WRITE with SG_TO_MEM_NOALLOC
	handling
Date: Wed, 8 Apr 2015 18:33:31 +0200
Message-ID: <20150408163331.GA3447@lst.de>
References: <1428449682-387-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1428449682-387-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

This fixes the crash that I saw, but the Compare and Write testcast
in the scsi testsuite still fails..
