From: Jordan Breeding <jordan.breeding@attbi.com>
Subject: scsi write barriers (ordered tags)?
Date: Wed, 05 Feb 2003 10:00:48 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E413530.8060103@attbi.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9D99DDDF1E831E5C2144B540"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9D99DDDF1E831E5C2144B540
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Today regarding his message about ide write barriers I got the following 
message:

Jens Axboe wrote:
> On Wed, Feb 05 2003, Jordan Breeding wrote:
> 
>>Jens Axboe wrote:
>>
>>>Hi,
>>>
>>>The attached patch implements write barrier operations in the block
>>>layer and for IDE, specifically. The goal is to make the use of write
>>>back cache enabled ide drives safe with journalled file systems.
>>>
>>>Patch is against 2.4.21-pre4-bk as of today, and includes a small patch
>>>to enable it on ext3. Chris has a patch for reiserfs as well.
>>>
>>
>>Does the above mean that the patch only works for IDE and not for SCSI? 
> 
> 
> The above is just for IDE.
> 
> 
>> If so when will SCSI be able to use write back cache safely?  Also, 
> 
> 
> Hmmm well, it's simple enough to make the low level driver generate an
> ordered tag when appropriate, but it's very tricky to make sure that no
> re-ordering takes place in case of errors, timeouts, etc.
> 
> 
>>will this patch be ported to 2.5.x or is it already present there?  Thanks.
> 
> 
> Block layer infrastructure is there, has been since bio was merged in
> 2.5.1-pre. The ide bits will be send for inclusion shortly.
> 

The part I am concerned with is his statement about SCSI being harder to 
implement this on.  I guess this doesn't matter as much since my SCSI 
drive with write back cache off is faster than any IDE drive I have used 
with it on, but still it would be nice to be able to run both type of 
drives with the write back cache on.  So my question is, are the things 
Jens stated above about SCSI enough to keep this feature completely out 
of 2.5.x even once IDE has the code merged, or will SCSI be able to have 
this feature as well by 2.6?  Thanks for any info and/or speculation 
about this.

Jordan

--------------enig9D99DDDF1E831E5C2144B540
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQE+QTU1SigNyqq/SRwRAqlPAKDME0wbJxVMABZ0JMVy59uLtwSILACgwEku
Ng52SQG9sUbMsGRny4TMTlo=
=dEDy
-----END PGP SIGNATURE-----

--------------enig9D99DDDF1E831E5C2144B540--

