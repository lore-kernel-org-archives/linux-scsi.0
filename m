From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [libsas PATCH v13] scsi, sd: limit the scope of the async probe domain
Date: Thu, 17 May 2012 15:15:14 -0700
Message-ID: <CABE8wwuaVwPd48LmOOcOu+6rU+Jv6s+ut0c7uD3AiU0WH6eebg@mail.gmail.com>
References: <20120323000201.17750.18754.stgit@dwillia2-linux.jf.intel.com>
	<1337242396.2926.16.camel@dabdike.int.hansenpartnership.com>
	<CABE8wwtNJ1C8petYHfHn0kCwNx9Qt4FC27E61atWLaJWxTGYtg@mail.gmail.com>
	<1337264052.30498.29.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1337264052.30498.29.camel@dabdike.int.hansenpartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
List-Id: linux-scsi@vger.kernel.org

On Thu, May 17, 2012 at 7:14 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> Lets try a pull request on the isc branch at least ... can you send me
> one with a signed tag?

Can do.

To make the merge cleaner I will rebase the isci tree to have zero
dependencies on the pending libsas update (which adds suspend/resume
support).  Then after you have a chance to merge the libsas update [1]
I'll send a final patch to enable suspend/resume for isci.

--
Dan

[1]: http://marc.info/?l=linux-scsi&m=133632746229553&w=2
