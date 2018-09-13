From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [Announce] sg3_utils-1.44 available
Date: Wed, 12 Sep 2018 21:41:16 -0400
Message-ID: <06575258-57b6-95f0-061b-0219e6481338@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Martin Pitt <mpitt@debian.org>, David Sommerseth <davids@redhat.com>, Hannes Reinecke <hare@suse.de>, Ritesh Raj Sarraf <rrs@researchut.com>, "Robin H. Johnson" <robbat2@gentoo.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Lack of synchronization between my subversion repository and the official
git mirror led to this release tag:
    https://github.com/hreinecke/sg3_utils/releases/tag/v1.43
dated 20160218 (my svn revision 665). That led some distributions to
believe that sg3_utils-1.43 was released over 2.5 years ago, rather
than yesterday.

Clean up the discrepancy by rolling forward to sg3_utils-1.44 with
minimal changes from the release yesterday (basically just changing
1.43 to 1.44 in several places). All tarballs and packages have been
regenerated.

Otherwise the release announcement for 1.43 from yesterday still applies:
   https://www.spinics.net/lists/linux-scsi/msg123230.html


Distributions: please use sg3_utils-1.44 to minimize further confusion.
Future changes will go into 1.45 .

Doug Gilbert
