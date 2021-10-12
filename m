Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF1D6C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 22:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3F5F60E53
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 22:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbhJLXBZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:01:25 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:59574 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232419AbhJLXBY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:01:24 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 19CMxB6M018471
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 18:59:12 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 08E6915C00CA; Tue, 12 Oct 2021 18:59:11 -0400 (EDT)
Date:   Tue, 12 Oct 2021 18:59:10 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: Meeting about the UFS driver
Message-ID: <YWYTPnEBGatnfmO4@mit.edu>
References: <4942b187-f6ab-e93f-604b-df635043c2bb@acm.org>
 <6c9f6faf1e4a3dddbd4276402cb38318a99b6026.camel@HansenPartnership.com>
 <bb051910-43cd-9007-9267-3579765137cb@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb051910-43cd-9007-9267-3579765137cb@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 12, 2021 at 11:05:55AM -0700, Bart Van Assche wrote:
> That document has been created using my work account. Recently my employer
> changed the settings for work documents such that even read-only access has
> to be granted explicitly. Making a document viewable without authentication
> is no longer supported. I am considering next time I use Google Docs to
> prepare a meeting to use my personal gmail account since making documents
> public from a personal account is still supported.

Yeah, that would be my strong recommendation.  My employer has the
same restriction and I similarly will make sure that I create such
documents using my personal gmail account and then share Editor status
with my work account so I can more easily edit it from my work account
if necessary.

If you have a document that was created with your work account, the
procedure to "transfer" it over to your personal account is:

* If necessary, remove any work-proprietary information from the
  document; you can revert that change at the end of this procedure
  if you want the work version of the document to have internal
  information in it
* share the document with your personal account
* open the document with your personal account
* select File->Make a copy to make a copy of that document
  which is owned by your personal account
* Rename the copy so that it has something thing like (PUBLIC)
  in the the name so you can easily disambiguate the public
  version from the work version.
  OR, delete the work version of the document so you don't end
  up confusing yourself.
* Enable link sharing on the public version of the document

If you've ever wondered why the document which you can reach via the
URL https://thunk.org/gce-xfstests has "(public)" in the title, that's
why....

It's a bit more work for you, but it makes much life much easier for
everyone else trying to access the document.

Cheers,

					- Ted
